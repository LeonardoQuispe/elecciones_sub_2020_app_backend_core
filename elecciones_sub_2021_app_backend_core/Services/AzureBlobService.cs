

using Microsoft.AspNetCore.Http;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace elecciones_sub_2021_app_backend_core.Services
{
	public interface IAzureBlobService
	{
		Task<IEnumerable<Uri>> ListAsync();
		Task UploadAsync(IFormFileCollection files);
		Task<bool> UploadAsync(IFormFile file, string nombreArchivo = null, string mimeType = null);
		Task DeleteAsync(string fileUri);
		Task DeleteAllAsync();
	}

	public class AzureBlobService : IAzureBlobService
	{
		private readonly IAzureBlobConnectionFactory _azureBlobConnectionFactory;

		public AzureBlobService(IAzureBlobConnectionFactory azureBlobConnectionFactory)
		{
			_azureBlobConnectionFactory = azureBlobConnectionFactory;
		}

		public async Task DeleteAllAsync()
		{
			var blobContainer = await _azureBlobConnectionFactory.GetBlobContainer();

			BlobContinuationToken blobContinuationToken = null;
			do
			{
				var response = await blobContainer.ListBlobsSegmentedAsync(blobContinuationToken);
				foreach (IListBlobItem blob in response.Results)
				{
					if (blob.GetType() == typeof(CloudBlockBlob))
						await ((CloudBlockBlob)blob).DeleteIfExistsAsync();
				}
				blobContinuationToken = response.ContinuationToken;
			} while (blobContinuationToken != null);
		}

		public async Task DeleteAsync(string fileUri)
		{
			var blobContainer = await _azureBlobConnectionFactory.GetBlobContainer();

			Uri uri = new Uri(fileUri);
			string filename = Path.GetFileName(uri.LocalPath);

			var blob = blobContainer.GetBlockBlobReference(filename);
			await blob.DeleteIfExistsAsync();
		}

		public async Task<IEnumerable<Uri>> ListAsync()
		{
			var blobContainer = await _azureBlobConnectionFactory.GetBlobContainer();
			var allBlobs = new List<Uri>();
			BlobContinuationToken blobContinuationToken = null;
			do
			{
				var response = await blobContainer.ListBlobsSegmentedAsync(blobContinuationToken);
				foreach (IListBlobItem blob in response.Results)
				{
					if (blob.GetType() == typeof(CloudBlockBlob))
						allBlobs.Add(blob.Uri);
				}
				blobContinuationToken = response.ContinuationToken;
			} while (blobContinuationToken != null);
			return allBlobs;
		}

		public async Task UploadAsync(IFormFileCollection files)
		{
			var blobContainer = await _azureBlobConnectionFactory.GetBlobContainer();

			for (int i = 0; i < files.Count; i++)
			{
				var blob = blobContainer.GetBlockBlobReference(GetRandomBlobName(files[i].FileName));
				blob.Properties.ContentType = files[i].ContentType;
				using (var stream = files[i].OpenReadStream())
				{
					await blob.UploadFromStreamAsync(stream);

				}
			}
		}

		public async Task<bool> UploadAsync(IFormFile file, string nombreArchivo = null, string mimeType = null)
		{
			try
			{
				var blobContainer = await _azureBlobConnectionFactory.GetBlobContainer();

				// var blob = blobContainer.GetBlockBlobReference(GetRandomBlobName(file.FileName));  // le da un nombre ramdonico
				var blob = blobContainer.GetBlockBlobReference(nombreArchivo == null ? file.FileName : nombreArchivo);
				blob.Properties.ContentType = mimeType == null ? file.ContentType : mimeType;
				using (var stream = file.OpenReadStream())
				{
					await blob.UploadFromStreamAsync(stream);

				}
				return true;
			}
			catch (Exception ex)
			{
				return false;
				throw ex;
			}
		}

		/// <summary> 
		/// string GetRandomBlobName(string filename): Generates a unique random file name to be uploaded  
		/// </summary> 
		private string GetRandomBlobName(string filename)
		{
			string ext = Path.GetExtension(filename);
			return string.Format("{0:10}_{1}{2}", DateTime.Now.Ticks, Guid.NewGuid(), ext);
		}
	}
}