# Heroku Deployment Guide

This guide provides instructions for deploying the Synergym application to Heroku.

## Prerequisites

1. Install the Heroku CLI:
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku
   
   # Ubuntu/Debian
   wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
   ```

2. Log in to Heroku:
   ```bash
   heroku login
   ```

3. Install the Heroku PostgreSQL addon (optional, can be added later):
   ```bash
   # This will be added during deployment setup
   ```

## Deployment Steps

1. **Create a new Heroku app**:
   ```bash
   heroku create synergym-app
   ```

2. **Add PostgreSQL addon**:
   ```bash
   # First check available plans
   heroku addons:plans heroku-postgresql
   
   # Then create with an available plan (e.g., essential-0)
   heroku addons:create heroku-postgresql:essential-0
   ```

3. **Add Redis addon for Sidekiq**:
   ```bash
   # First check available plans
   heroku addons:plans heroku-redis
   
   # Then create with an available plan (e.g., hobby-dev)
   heroku addons:create heroku-redis:hobby-dev
   ```

4. **Set environment variables**:
   ```bash
   heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
   heroku config:set RAILS_LOG_TO_STDOUT=true
   heroku config:set RAILS_SERVE_STATIC_FILES=true
   ```

5. **Configure Redis URL** (if not automatically set):
   ```bash
   # Get Redis URL from Heroku
   heroku config:get REDIS_URL
   
   # If not set, set it manually
   heroku config:set REDIS_URL=$(heroku config:get HEROKU_REDIS_URL)
   ```

6. **Push to Heroku**:
   ```bash
   git add .
   git commit -m "Configure for Heroku deployment"
   git push heroku main
   ```

7. **Run database migrations**:
   ```bash
   heroku run rails db:migrate
   ```

8. **Seed the database** (if needed):
   ```bash
   heroku run rails db:seed
   ```

9. **Scale the dynos**:
   ```bash
   heroku ps:scale web=1 worker=1
   ```

## Monitoring

1. **View logs**:
   ```bash
   heroku logs --tail
   ```

2. **View specific process logs**:
   ```bash
   heroku logs --tail --ps web
   heroku logs --tail --ps worker
   ```

3. **Open the app**:
   ```bash
   heroku open
   ```

## Troubleshooting

1. **If migrations fail**:
   ```bash
   heroku run rails db:migrate:reset
   ```

2. **If assets aren't loading**:
   ```bash
   heroku run rails assets:precompile
   ```

3. **If Sidekiq isn't processing jobs**:
   ```bash
   heroku restart worker
   ```

4. **Check configuration**:
   ```bash
   heroku config
   ```

## Custom Domain (Optional)

1. **Add custom domain**:
   ```bash
   heroku domains:add yourdomain.com
   heroku domains:add www.yourdomain.com
   ```

2. **Update DNS settings**:
   Follow the instructions provided by Heroku after adding the domain.
   - For root domain (synergym.fit): Use ALIAS or ANAME record pointing to the DNS target
   - For subdomain (www.synergym.fit): Use CNAME record pointing to the DNS target

3. **Wait for domain propagation**:
   ```bash
   heroku domains:wait 'yourdomain.com'
   ```

4. **Update Rails configuration**:
   Add your custom domains to the `config.hosts` array in `config/environments/production.rb`

## One-Click Deployment

For a simpler deployment experience, consider using the Heroku Button:

1. Add the following to your README.md:
   ```markdown
   [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
   ```

2. Create an `app.json` file with your app configuration.

## CI/CD with GitHub Actions (Optional)

For automated deployments, you can set up GitHub Actions:

1. Create `.github/workflows/deploy.yml` with your deployment workflow.
2. Add Heroku API key as a secret in your GitHub repository.
3. Configure the workflow to automatically deploy on push to main branch.